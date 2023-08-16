import { userFcmTokensRef } from '../firestore-refs/firestoreRefs'
import { UserFcmToken } from '../models/userFcmToken'

/** UserFcmToken のリポジトリクラス */
export class UserFcmTokenRepository {
    /** 指定した userId の UserFcmToken のリスト を取得する。 */
    async fetchUserFcmTokens({ userId }: { userId: string }): Promise<UserFcmToken[]> {
        const qs = await userFcmTokensRef.where("userId", "==", userId).get()
        return qs.docs.map((a) => a.data())
    }
}
