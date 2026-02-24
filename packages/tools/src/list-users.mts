import setup from './utils/setup.mts';

async function main() {
  const { collections } = await setup();

  const allUsers = await collections['app-users'].findMany({
    name: 'all users',
  });

  console.table(allUsers);
}

await main();
