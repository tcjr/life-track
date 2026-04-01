import { onCall, HttpsError } from 'firebase-functions/v2/https';
import * as logger from 'firebase-functions/logger';
import setup from './utils/setup.mjs';

interface CreateReportData {
  title: string;
  startDate: string; // ISO string
  endDate: string; // ISO string
  measurements: ('bps' | 'glucoses')[];
}

export const createReport = onCall<CreateReportData>(
  { cors: true },
  async (request) => {
    // Check auth
    if (!request.auth) {
      throw new HttpsError(
        'unauthenticated',
        'User must be logged in to create a report.',
      );
    }

    const { collections } = await setup();
    const { title, startDate, endDate, measurements } = request.data;
    const uid = request.auth.uid;

    const start = new Date(startDate);
    const end = new Date(endDate);

    const reportData: any = {};

    for (const type of measurements) {
      logger.info(
        `Fetching ${type} for user ${uid} between ${startDate} and ${endDate}`,
      );

      // Use the typed collections from setup()
      const userCollections = collections['app-users'](uid);
      let items: any[] = [];

      if (type === 'bps') {
        items = await userCollections.bps.findMany({
          name: `report-bps-${uid}`,
          where: [
            ['timestamp', '>=', start],
            ['timestamp', '<=', end],
          ],
          orderBy: [['timestamp', 'asc']],
        });
      } else if (type === 'glucoses') {
        items = await userCollections.glucoses.findMany({
          name: `report-glucoses-${uid}`,
          where: [
            ['timestamp', '>=', start],
            ['timestamp', '<=', end],
          ],
          orderBy: [['timestamp', 'asc']],
        });
      }

      console.log(`Found ${items.length} '${type}' items, adding to report`);
      reportData[type] = items;
    }

    console.log('Creating report...');
    const reportRef = await collections.reports.add({
      title,
      userId: uid,
      startDate: start,
      endDate: end,
      createdAt: new Date(),
      bps: [],
      glucoses: [],
      ...reportData,
    });
    console.log(`Report created with ID: ${reportRef.id}`);

    return { id: reportRef.id };
  },
);
