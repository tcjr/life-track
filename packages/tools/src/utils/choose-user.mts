import { select, isCancel, cancel } from '@clack/prompts';

export async function chooseUser(collections: any) {
  const allUsers = await collections['app-users'].findMany({
    name: 'all users',
  });

  if (allUsers.length === 0) {
    throw new Error('No users found in the database.');
  }

  const options = allUsers.map((user: any) => ({
    value: user._id,
    label: user._id,
    hint: user.isSetup ? 'Setup complete' : 'Not setup',
  }));

  const userId = await select({
    message: 'Select a user:',
    options,
  });

  if (isCancel(userId)) {
    cancel('Operation cancelled.');
    process.exit(0);
  }

  return userId as string;
}
