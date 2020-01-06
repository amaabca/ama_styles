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
console.log(JSON.stringify(data));
