import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

/**
 * 新しい disableUserAccountRequest ドキュメントが作成されたときに発火する。
 * disableUserAccountRequest を作成したユーザーを disable にする。
 */
export const onCreateDisableUserAccountRequest = functions
    .region(`asia-northeast1`)
    .firestore.document(`/disableUserAccountRequests/{disableUserAccountRequest}`)
    .onCreate(async (snapshot) => {
        const disableUserAccountRequest = snapshot.data()
        const userId = disableUserAccountRequest.userId
        try {
          await admin.auth().updateUser(userId, { disabled: true });
        } catch (e) {
          functions.logger.error(`退会処理に失敗しました。${e}`)
        }
    })
