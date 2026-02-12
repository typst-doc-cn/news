import { concurrently } from "concurrently";

concurrently([
  {
    name: "build",
    command: "npm run build -- --dev --base http://localhost:3000/news/",
  },
  {
    name: "serve",
    command: "npm run serve -- --base /news/ --open",
  },
], {
  killOthersOn: ["failure", "success"],
  prefixColors: "auto",
});
