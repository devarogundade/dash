import Vue from "vue";
import Push from "push.js";

export default ({}, inject) => {
    inject('notifier', Vue.observable({
        message: null,
        notify: async function(message) {
            try {
                this.message = message

                if (!Push.Permission.has()) {
                    Push.Permission.request(this.granted(), this.denied());
                    return
                }

                if (this.message != null) {
                    this.send(this.message)
                    this.message = null
                }
                return response.data
            } catch (error) {
                return null
            }
        },
        granted: function() {
            if (this.message != null) {
                this.send(this.message)
                this.message = null
            }
        },
        denied: function() {},
        send: function(message) {
            Push.create(message.title, {
                body: message.body,
                icon: '/favicon.ico',
                timeout: 10000,
                onClick: function() {
                    window.focus()
                    this.close()
                }
            });
        }
    }))
}