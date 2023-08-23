import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions/v2'

import * as serviceAccountKey from '../service_account_keys/dev_service_account_key.json'

/** サービスアカウント */
const serviceAccount = {
    type: serviceAccountKey.type,
    projectId: serviceAccountKey.project_id,
    privateKeyId: serviceAccountKey.private_key_id,
    privateKey: serviceAccountKey.private_key.replace(/\\n/g, `\n`),
    clientEmail: serviceAccountKey.client_email,
    clientId: serviceAccountKey.client_id,
    authUri: serviceAccountKey.auth_uri,
    tokenUri: serviceAccountKey.token_uri,
    authProviderX509CertUrl: serviceAccountKey.auth_provider_x509_cert_url,
    clientC509CertUrl: serviceAccountKey.client_x509_cert_url
}

// Firebase Admin SDK の初期化。
// https://firebase.google.com/docs/functions/config-env?hl=ja
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: `https://${serviceAccount.projectId}.firebaseio.com`
})

/** Firebase Functions のグローバル設定。 */
functions.setGlobalOptions({ region: `asia-northeast1` })

/** ここでデプロイする関数をまとめる。 */
import { createfirebaseauthcustomtoken } from './callable-functions/createFirebaseAuthCustomToken'
import { notificationSlack } from './callable-functions/notificationSlack'

/** index.ts で import してデプロイする関数一覧。 */
export { createfirebaseauthcustomtoken, notificationSlack }
