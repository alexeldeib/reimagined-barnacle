# reimagined-barnacle

a quick demo of a dockerized teleport server on fly.io + github SSO.

currently configured for DNS using "port.alexeldeib.xyz" hardcoded in a few places.
- https://github.com/alexeldeib/reimagined-barnacle/blob/main/Dockerfile#L27
- https://github.com/alexeldeib/reimagined-barnacle/blob/main/cap.yaml#L7
- https://github.com/alexeldeib/reimagined-barnacle/blob/main/github.yaml#L14

also hardcoded for Github SSO to an org I manage:
- https://github.com/alexeldeib/reimagined-barnacle/blob/a1ee176afa64805d5afae40e11b8ecebca9dab0f/github.yaml#L17-L18

and you will need a github app (my values censored):
- https://github.com/alexeldeib/reimagined-barnacle/blob/a1ee176afa64805d5afae40e11b8ecebca9dab0f/github.yaml#L7-L10

For Github OAuth integration, refer to https://goteleport.com/docs/access-controls/sso/github-sso/

I created a new Github org with a team for just myself + friends.

# deployment

after configuring all that:
- flyctl launch/deploy https://fly.io/docs/flyctl/launch/
  - optionally, reserve an IP with Fly before deploying, and configure DNS first
- Configure DNS: https://goteleport.com/docs/deploy-a-cluster/open-source/#step-16-configure-dns
  - wildcard A records for domain/subdomains
- Wait a bit
- Go to DNS name in browser

the deployment creates the app on fly, using the dockerfile to host the server for all the necessary services.
it applies the SSO and role config as post-deploy steps using the flyctl CLI locally on the server.
