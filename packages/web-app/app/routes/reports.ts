import Route from '@ember/routing/route';

export default class ReportsRoute extends Route {
  model(params: { report_id: string }) {
    return {
      id: params.report_id,
    };
  }
}
