import EmlParser from './eml-to-html.js';
import fs from 'fs';

console.log(process.argv[2])
const emailFile = process.argv[2]
const htmlDestinationPath = process.argv[3]

const emailFileStream = fs.createReadStream(emailFile);

// convert to html
new EmlParser(emailFileStream)
.getEmailAsHtml()
.then(htmlString => {
	fs.writeFileSync(htmlDestinationPath + '.html', htmlString)	;
})
.catch(err => {
	console.log(err);
})
