/**
 * LINE のログイン関係の API のレスポンスを定義する。
 * 参考：https://developers.line.biz/ja/reference/line-login/
 */

/**
 * GET https://api.line.me/oauth2/v2.1/verify のレスポンス。
 * https://developers.line.biz/ja/reference/line-login/#verify-access-token
 */
interface LINEGetVerifyAPIResponse {
    scope: string
    client_id: string
    expires_in: number
}

/** GET https://api.line.me/v2/profile のレスポンス。 */
/**
 * GET https://api.line.me/v2/profile のレスポンス。
 * https://developers.line.biz/ja/reference/line-login/#get-user-profile
 */
interface LINEGetProfileResponse {
    userId: string
    displayName: string
    pictureUrl?: string
    statusMessage?: string
}
