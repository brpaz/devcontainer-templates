const fs = require("fs");
const path = require("path");

// get version from first arg, returning and error if not provided
const version = process.argv[2];

if (!version) {
    console.error("No version provided");
    process.exit(1);
}

const versionParts = version.split("-");

if (versionParts.length < 2) {
    console.error("Invalid version provided");
    process.exit(1);
}

// get last part of version and join the rest back together
const tag = versionParts.pop();
const component = versionParts.join("-");

const templatePath = path.resolve(__dirname, `../src/${component}/devcontainer-template.json`);

// read the template file
const template = JSON.parse(fs.readFileSync(templatePath, "utf8"));

// update the version
template.version = tag;

// write the updated template file
fs.writeFileSync(templatePath, JSON.stringify(template, null, 4));

console.log(`Bumped version to ${tag} for ${component}`);



