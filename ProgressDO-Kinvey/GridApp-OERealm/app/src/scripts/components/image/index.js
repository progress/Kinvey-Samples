///////////////////
// Auto-generated
// Do not edit!!!
///////////////////
'use strict';

import template from './template.html';

function directive() {
    return {
        restrict: 'E',
        scope: true,
        bindToController: {
            id: '@',
            src: '=',
            width: '=',
            height: '=',
            alt: '='
        },
        controllerAs: 'vm',
        templateUrl: template
    };
}

export default directive;