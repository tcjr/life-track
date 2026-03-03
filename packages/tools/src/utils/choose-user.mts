import { type Collections } from 'zod-firebase-admin';
import { select, isCancel, cancel } from '@clack/prompts';
import { type AppUser } from '../models/app-user.mts';
import { schema } from './setup.mts';

export async function chooseUser(collections: Collections<typeof schema>) {
  const allUsers = await collections['app-users'].findMany({
    name: 'all users',
  });

  if (allUsers.length === 0) {
    throw new Error('No users found in the database.');
  }

  const options = allUsers.map((user: AppUser) => ({
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
