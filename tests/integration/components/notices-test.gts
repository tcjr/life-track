import { module, test } from 'qunit';
import { setupRenderingTest } from 'life-track/tests/helpers';
import { render } from '@ember/test-helpers';
import Notices from 'life-track/templates/notices';

module('Integration | Component | notices', function (hooks) {
  setupRenderingTest(hooks);

  test.skip('it renders', async function (assert) {
    // TODO: figure out how to set up the test environment with Firestore data, so we can test the actual rendering of notices.

    await render(<template><Notices /></template>);

    assert.dom().hasText('wassup');
  });
});
