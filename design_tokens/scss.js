import fs from 'fs';
import theo from 'theo';

const options = {
  transform: {
    type: 'web',
    file: 'buttons.yml'
  },
  format: {
    type: 'scss'
  }
};

const data = theo.convertSync(options);
const content = new Uint8Array(Buffer.from(data));
fs.writeFileSync('../app/assets/stylesheets/_design_tokens.scss', content);
console.log('Wrote: app/assets/stylesheets/_design_token.scss');
