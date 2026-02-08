import { z } from 'zod';
import { zodFirestoreConverter } from './utils';

export const AppUserSchema = z.object({
  isSetup: z.boolean(),
  theme: z.enum(['light', 'dark', 'system']),
});

export type AppUser = z.infer<typeof AppUserSchema> & { id: string };

export const appUserConverter = zodFirestoreConverter(AppUserSchema);
