import { pageTitle } from 'ember-page-title';
import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { dataFromEvent } from 'ember-primitives/components/form';
import type { MealInput } from '#app/models/measurements/meal.ts';
import { collections } from '#app/models/collections.ts';
import { service } from '@ember/service';
import type FirebaseService from '#app/services/firebase.ts';
import type { FlashMessagesService } from 'ember-cli-flash';
import InputNumber from '#app/components/input-number.gts';
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
      //notes: formData.notes,
      timestamp: new Date(),
    };

    try {
      await collections['app-users'](this.firebase.uid).meals.add(updateData);
      this.flashMessages.success('Meal added');
      this.router.transitionTo('authenticated.index');
    } catch (e) {
      this.flashMessages.danger('Error adding meal');
      console.error('attempted data', updateData, e);
    }
  };

  get prefillValues() {
    return {
      value: '150',
    };
  }

  <template>
    {{pageTitle "New Meal"}}
    <div ...attributes>

      <h1>New Meal</h1>
      <form {{on "submit" this.handleSubmit}}>
        <div class="text-2xl font-bold text-center">Meal</div>
        <div class="flex flex-col">
          <label for="notes" class="text-center italic text-sm">notes</label>
          <input name="notes" value="" placeholder="optional notes" />
        </div>
        <button
          type="submit"
          class="btn btn-secondary btn-xl w-full mt-6"
        >Save</button>
      </form>
    </div>
  </template>
}
