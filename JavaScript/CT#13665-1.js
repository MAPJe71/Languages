/*
    https://notepad-plus-plus.org/community/topic/13665/function-list-doesn-t-show-classes-in-js-ecmascript
*/

class Scene {

    constructor() {
        this.status = "inactive";
    }

    activate() {
        if (this.status === "inactive") {
            this.status = "active";
        }
    }

    deactivate() {
        if (this.status === "active") {
            this.status = "inactive";
        }
    }
}
