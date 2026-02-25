import { pageTitle } from 'ember-page-title';
import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { dataFromEvent } from 'ember-primitives/components/form';
import type { MealInput } from '#app/models/measurements/meal.ts';
import { collections } from '#app/models/collections.ts';
import { service } from '@ember/service';
import type FirebaseService from '#app/services/firebase.ts';
import type { FlashMessagesService } from 'ember-cli-flash';
import type RouterService from '@ember/routing/router-service';

interface NewMealSignature {
  Element: HTMLDivElement;
}

export default class NewMeal extends Component<NewMealSignature> {
  @service declare firebase: FirebaseService;
  @service declare flashMessages: FlashMessagesService;
  @service declare router: RouterService;

  handleSubmit = async (e: Event) => {
    e.preventDefault();
    const formData = dataFromEvent(e);
    const updateData: MealInput = {
      notes: (formData.notes || '') as string,
      timestamp: new Date(),
    };

    try {
      await collections['app-users'](this.firebase.uid).meals.add(updateData);
      this.flashMessages.success('Meal added');
      this.router.transitionTo('authenticated.new-measurement');
    } catch (e) {
      this.flashMessages.danger('Error adding meal');
      console.error('attempted data', updateData, e);
    }
  };

  <template>
    {{pageTitle "New Meal"}}
    <div ...attributes>

      <form {{on "submit" this.handleSubmit}}>
        <div class="text-2xl font-bold text-center">Meal</div>
        <div class="flex flex-col">
          <label for="notes" class="text-center italic text-sm">optional notes</label>
          <input
            name="notes"
            id="notes"
            value=""
            placeholder="light breakfast, etc"
            class="input w-full"
          />
        </div>
        <button
          type="submit"
          class="btn btn-secondary btn-xl w-full mt-6"
        >Save</button>
      </form>
    </div>
  </template>
}
