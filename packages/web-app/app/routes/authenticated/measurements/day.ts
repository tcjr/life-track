import Route from '@ember/routing/route';

export default class MeasurementsDayRoute extends Route {
  model(params: { yyyy_mm_dd: string }) {
    const day = params.yyyy_mm_dd;
    console.log('returning day ', day);
    return {
      day,
    };
  }
}
