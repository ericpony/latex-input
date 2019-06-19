const fs = require('fs');
const readline = require('readline');
const argsParser = require('command-line-args')
const usagePrinter = require('command-line-usage');
const optionSpec = [
  { name: 'src', alias: 'i', type: String, typeLabel: '{underline file}', defaultOption: true, 
    description: 'The file to be sanitised; omit to read from stdin.' },
  { name: 'dest', alias: 'o', type: String, typeLabel: '{underline file}',
    description: 'The file to be saved; omit to write to stdout.' },
  { name: 'dict', alias: 'd', type: String, typeLabel: '{underline file}',
    defaultValue: __dirname + "/table.dat", description: 'The unicode-to-latex map file. (Default: table.dat)' },
  { name: 'help', alias: 'h', type: Boolean, description: 'Display this usage guide.' }
];
const options = argsParser(optionSpec);
if(options.help) {
  const sections = [
    {
      header: 'LaTex Unicode Sanitiser',
      content: 'Convert mathematical symbols in unicode to their corresponding LaTex notation.'
    },
    {
      header: 'Synopsis',
      content: [
        '$ node sanitise.js [{bold --src} {underline file}] [{bold --dest} {underline file}] [{bold --dict} {underline file}]',
        '$ node sanitise.js {bold --help}'
      ]
    },
    {
      header: 'Options',
      optionList: optionSpec
    },
    {
      content: 'Project home: {underline https://github.com/ericpony/latex-input}'
    }
  ];
  console.log(usagePrinter(sections));
  process.exit();
}
let dict = {};
let readable = fs.createReadStream(options.dict, {
  encoding: "utf8",
  fd: null,
});
const readInterface = readline.createInterface({  
  input: readable,
  output: false
});
readInterface.on("line", line => {
  let pair = line.split(" ");
  if(pair.length==2)
  dict[pair[1]] = pair[0];
});

readInterface.on("close", () => {
  if(options.src) {
    readable = fs.createReadStream(options.src, {
      encoding: "utf8",
      fd: null,
    });
  }else {
    readable = process.stdin;
    readable.setEncoding("utf8");
  }
  if(options.dest) {
    writable = fs.createWriteStream(options.dest, {
      encoding: "utf8",
      fd: null,
    });
  }else {
    writable = process.stdout;
    writable.setEncoding("utf8");
  }
  readable.on("readable", function() {
    const threshold = 126;
    let chunk;
    let seen = false;
    let lineNo = 1;
    while (null !== (chunk = readable.read(1) /* here */)) {
      //chunk = chunk.toString('utf8');
      if(chunk=="\n")
        lineNo++;
      //console.log('chunk: ' + typeof chunk);
      if(chunk.charCodeAt(0)>threshold) {
        let symbol = dict[chunk];
        if(!symbol) {
          console.error("Unrecognised unicode at line " + lineNo + ": " + chunk);
          symbol = "??";
        }
        chunk = symbol;
        seen = true;
      }else {
        if(seen){
          if(![" ", "\\", "$", ".", ",", "\n"].some(c => c==chunk)) {
            chunk = " " + chunk;
          }
        }
        seen = false;
      }
      writable.write(chunk);
    }
  });
});
