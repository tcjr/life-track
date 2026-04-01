import setup from './utils/setup.mts';

async function main() {
  const { collections } = await setup();

  const allReports = await collections.reports.findMany({
    name: 'all reports',
    orderBy: [['createdAt', 'desc']],
  });

  if (allReports.length === 0) {
    console.log('No reports found.');
    return;
  }

  console.log(`Found ${allReports.length} reports:`);
  console.table(allReports.map(r => ({
    id: r._id,
    title: r.title,
    userId: r.userId,
    created: r.createdAt.toLocaleString(),
    range: `${r.startDate.toLocaleDateString()} - ${r.endDate.toLocaleDateString()}`
  })));
}

await main();
