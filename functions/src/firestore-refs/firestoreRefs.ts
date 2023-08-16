import { CollectionReference } from '@google-cloud/firestore'
import * as admin from 'firebase-admin'
import { userFcmTokenConverter } from '../converters/userFcmToken'
import { UserFcmToken } from '../models/userFcmToken'

/** undefined なプロパティを無視するよう設定した db オブジェクト。 */
const db = admin.firestore()
db.settings({ ignoreUndefinedProperties: true })

/// fcmTokens コレクションの参照 */
export const userFcmTokensRef: CollectionReference<UserFcmToken> = db
    .collection(`fcmTokens`)
    .withConverter<UserFcmToken>(userFcmTokenConverter)
