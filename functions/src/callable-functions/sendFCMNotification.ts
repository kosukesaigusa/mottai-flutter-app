import { messaging } from 'firebase-admin'
import * as functions from 'firebase-functions'
import { UserFcmTokenRepository } from '../repositories/userFcmToken'

/**
 * 1次元配列を 500 要素ずつの 2 次元配列に分割する
 */
const arrayChunk = ([...array], size = 500): string[][] => {
    return array.reduce((acc, _, index) => (index % size ? acc : [...acc, array.slice(index, index + size)]), [])
}

interface FCMTarget {
    fcmTokens: string[]
    badgeNumber: number
}

/**
 * FCMTarget（FCM トークンのリスト、現在のバッジカウントのリスト）、
 * 通知内容、通知をタップしたときに遷移するべきページの情報を受け取って、通知を送信する。
 * ひとりひとり現在のバッジカウントが異なっており、各ユーザーの複数の FCM トークンごとに
 * messaging.MulticastMessage を用いて送信する。
 * ひとりが 500 個以上の異なるトークンを保持することは本来想定していないが、500 個ごとに
 * チャンクして送信する。
 */
export const sendFCMByTargets = async ({
    fcmTargets,
    title,
    body,
    location
}: {
    fcmTargets: FCMTarget[]
    title: string
    body: string
    location: string
    documentId?: string
}): Promise<void> => {

    for (const fcmTarget of fcmTargets) {
        const twoDimensionTokens = arrayChunk(fcmTarget.fcmTokens)
        for (let i = 0; i < twoDimensionTokens.length; i++) {
            const message: messaging.MulticastMessage = {
                tokens: twoDimensionTokens[i],
                notification: { title, body },
                data: {
                    title,
                    body,
                    location,
                    click_action: `FLUTTER_NOTIFICATION_CLICK`,
                    id: `1`,
                    status: `done`
                },
                apns: {
                    headers: { 'apns-priority': `10` },
                    payload: {
                        aps: {
                            contentAvailable: true,
                            badge: fcmTarget.badgeNumber,
                            sound: `default`
                        }
                    }
                },
                android: {
                    priority: `high`,
                    notification: {
                        priority: `max`,
                        defaultSound: true,
                        notificationCount: 0 // 増加数
                    }
                }
            }
            const response = await messaging().sendEachForMulticast(message)
            if (response.failureCount > 0) {
                const failedTokens: string[] = []
                response.responses.forEach((resp, j) => {
                    if (!resp.success) {
                        failedTokens.push(twoDimensionTokens[i][j])
                    }
                })
                functions.logger.warn(`送信に失敗した FCM Token（${response.failureCount}個）: ${failedTokens}`)
                return
            }
            functions.logger.log(`指定した全員に通知送信が成功しました`)
        }
    }
}

/**
 * 受け取った複数のユーザー ID 
 * sendFCMByTargets に処理を渡す。
 */
export const sendFCMByUserIds = async ({
    userIds,
    title,
    body,
    location
}: {
    userIds: string[]
    title: string
    body: string
    location: string
}): Promise<void> => {
    const fcmTargets: FCMTarget[] = []
    for (const userId of userIds) {
        const userFcmTokenRepository = new UserFcmTokenRepository()
        const userFcmTokens = await userFcmTokenRepository.fetchUserFcmTokens({ userId: userId })
        const fcmTokens = userFcmTokens.map(fcmToken => fcmToken.token);
        const badgeNumber = 0
        fcmTargets.push({ fcmTokens, badgeNumber })
    }
    await sendFCMByTargets({ fcmTargets, title, body, location })
}
