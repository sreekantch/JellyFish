(function() {
  'use strict';
  angular.module('app.states')
    .run(appRun);

  /** @ngInject */
  function appRun(routerHelper) {
    routerHelper.configureStates(getStates());
  }

  function getStates() {
    return {
      'authed': {
        abstract: true,
        template: '<ui-view></ui-view>'
      }
    };
  }
})();
