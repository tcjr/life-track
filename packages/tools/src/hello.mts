import { text, select, confirm, isCancel } from '@clack/prompts';

async function main() {
  // Get user's name
  const name = await text({
    message: 'What is your name?',
    placeholder: 'John Doe',
  }) as string;

  // Get user's favorite color
  const favoriteColor = await select({
    message: 'Favorite color:',
    options: [
      { value: 'red', label: 'Red' },
      { value: 'blue', label: 'Blue' },
      { value: 'green', label: 'Green' },
    ],
  });

  if (isCancel(favoriteColor)) {
    console.log('Operation cancelled');
    process.exit(0);
  }

  // Confirm the selection
  const shouldProceed = await confirm({
    message: `Create a ${favoriteColor} thing for ${name}?`,
  });

  if (shouldProceed) {
    console.log('Creating thing...');
  } else {
    console.log('Not creating anything.');
  }
}

await main();
