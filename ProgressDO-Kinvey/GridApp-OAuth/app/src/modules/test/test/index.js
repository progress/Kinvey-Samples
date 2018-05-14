///////////////////
// Auto-generated
// Do not edit!!!
///////////////////
'use strict';

import angular from 'angular';

import BaseController from './controller';
import Controller from './controller.public';
import routerEvents from './router-events';

import bottomSection from './bottomSection.html';
import middleSection from './middleSection.html';
import topSection from './topSection.html';

export default angular.module('views.test.test', [])
    .controller('TestTestCtrl', Controller)
    .factory('testTest', routerEvents)
    .run(['$templateCache', ($templateCache) => {
        $templateCache.put('views.test.test.bottomSection.html', bottomSection);
        $templateCache.put('views.test.test.middleSection.html', middleSection);
        $templateCache.put('views.test.test.topSection.html', topSection);
    }])
    .name;