import axios from 'axios';

/**
 * Slackへメッセージを通知する。
 * @param {message} message - 通知するテキスト
 * @throws {Error} 通知に失敗した場合、エラーを発報
 */
export const notificationSlack = async (message: string) => {
  const url = process.env.SLACK_URL;  // 環境変数からURLの取得
  if (!url) return;
  await axios.post(url, { text: message });
}
