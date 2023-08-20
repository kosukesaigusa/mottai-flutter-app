import * as functions from 'firebase-functions'
import { sendFCMByUserIds } from '../../callable-functions/sendFCMNotification'

/**
 * 新しい testNotification ドキュメントが作成されたときに発火する。
 * testNotificationを作成したユーザーにプッシュ通知を送信する。
 */
export const onCreateTestNotification = functions
    .region(`asia-northeast1`)
    .firestore.document(`/testNotifications/{testNotificationId}`)
    .onCreate(async (snapshot) => {
        const testNotiifcation = snapshot.data()
        const userId = testNotiifcation.userId
        try {
            await sendFCMByUserIds({
                userIds: [userId],
                title: `プッシュ通知から画面遷移をしてみよう！`,
                body: `サンプルのサインイン画面に遷移します！`,
                location: `/signInSample`
            })
        } catch (e) {
            functions.logger.error(`プッシュ通知の送信に失敗しました。${e}`)
        }
    })
