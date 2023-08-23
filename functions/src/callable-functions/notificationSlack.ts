import axios from 'axios';
import { https } from 'firebase-functions/v2';

export const notificationSlack = https.onRequest(async (request, response) => {
  if (request.method === `OPTIONS`) {
    response.set(`Access-Control-Allow-Methods`, `POST`);
    response.set(`Access-Control-Allow-Headers`, `Content-Type`);
    response.status(204).send(``);
  }
  else if (request.method === `POST`) {
    if (request.body[`text`]) {
      const endpoint = process.env.SLACK_ENDPOINT
      if (!endpoint) {
        response.status(400).send(`could not find SLACK_ENDPOINT`);
        return;
      }
      axios.post(endpoint, { text: request.body[`text`] });
      response.status(200).send(`OK`);
    }
    else {
      response.status(400).send(`invalid parameter. You must include 'text' param in the body`);
    }
  } else {
    response.status(405).send(`invalid method`);
  }
});
