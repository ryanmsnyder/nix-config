import { simpleParser } from 'mailparser';

export default function EmlParser (fileReadStream) {

    this.parsedEmail;

    this.parseEml = (options) => {
        return new Promise((resolve, reject) => {
            if (this.parsedEmail) {
                resolve(this.parsedEmail);
            } else {
                simpleParser(fileReadStream, {})
                    .then(result => {
                        if (options && options.ignoreEmbedded) {
                            result.attachments = result.attachments.filter(att => att.contentDisposition === 'attachment');
                        }
                        this.parsedEmail = result;
                        resolve(this.parsedEmail);
                    })
                    .catch(err => {
                        reject(err);
                    });
            }
        })
    }

    this.getEmailHeaders = () => {
        return new Promise((resolve, reject) => {
            this.parseEml()
                .then(result => {
                    let headers = {
                        subject: result.subject,
                        from: result.from.value,
                        to: result.to.value,
                        cc: result.cc?.value,
                        date: result.date,
                        inReplyTo: result?.inReplyTo,
                        messageId: result.messageId
                    }
                    resolve(headers)
                })
                .catch(err => {
                    reject(err);
                })
        })
    }


    this.getEmailBodyHtml = () => {
        let replacements = {
            "’": "'",
            "–": "&#9472;"
        }
        return new Promise((resolve, reject) => {
            this.parseEml()
                .then(result => {
                    let htmlString = result.html;
                    if (!htmlString) {
                        resolve('');
                    }
                    for (var key in replacements) {
                        let re = new RegExp(key, 'gi')
                        htmlString = htmlString.replace(re, replacements[key]);
                    }
                    resolve(htmlString);
                })
                .catch(err => {
                    reject(err);
                })

        })
    }

    this.getEmailAsHtml = () => {
        return new Promise((resolve, reject) => {
            this.parseEml()
                .then(result => {

                    let headerHtml = `
                    <div style="border:1px solid gray;margin-bottom:5px;padding:5px">
                        <h2>${result.subject}</h2>
                        <div style="display:flex;width:100%;">
                            <span style="font-weight:600;">From:&nbsp;${result.from.html}</span>
                            <span style="flex: 1 1 auto;"></span>
                            <span style="color:silver;font-weight:600">${new Date(result.date).toLocaleString()}</span>
                        </div>
                    `
                    if (result.to) {
                        headerHtml = headerHtml + `<div style="font-size:12px;">To:&nbsp;${result.to.html}</div>`
                    }
                    if (result.cc) {
                        headerHtml = headerHtml + `<div style="font-size:12px;">Cc:&nbsp;${result.cc.html}</div></div>`
                    } else {
                        headerHtml = headerHtml + `</div>`;
                    }
                    this.getEmailBodyHtml()
                        .then(bodyHtml => {
                            resolve(headerHtml + `<p>${bodyHtml}</p>`)
                        })
                        .catch(err => {
                            reject(err);
                        })
                })
                .catch(err => {
                    reject(err);
                })

        })
    }
}
