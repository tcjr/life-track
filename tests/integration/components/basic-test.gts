import { module, test } from 'qunit';
import { setupRenderingTest } from 'life-track/tests/helpers';
import { render } from '@ember/test-helpers';

module('Integration | Component | basic', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders dom', async function (assert) {
    const name = 'world';
    await render(
      <template>
        <h2>Hello {{name}}</h2>
      </template>
    );

    assert.dom().hasText('Hello world');
  });
});
