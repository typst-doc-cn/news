import { concurrently } from "concurrently";

concurrently([
  {
    name: "build",
    command: "npm run build -- --dev",
  },
  {
    name: "serve",
    command: "npm run serve",
  },
], {
  killOthersOn: ["failure", "success"],
  prefixColors: "auto",
});
