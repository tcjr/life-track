import { onRequest } from 'firebase-functions/https';
import * as logger from 'firebase-functions/logger';
import setup from './utils/setup.mjs';

export const listAllNotices = onRequest(async (request, response) => {
  const { collections } = await setup();

  try {
    logger.info('Listing all notices');
    const allNotices = await collections.notices.findMany({
      name: 'all-notices',
      limit: 10,
    });
    logger.info(`Found ${allNotices.length} notices`);
    response.send(JSON.stringify(allNotices));
  } catch (error) {
    logger.error(error);
    response.status(500).send('Internal Server Error (functions)');
  }
});
