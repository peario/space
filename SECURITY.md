# Security Policy

As of right now, there's no kind of versioning used for this config. Additionally it's not used my "daily driver" yet which means security updates are not a priority.

However, all and any issues related to security and vulnerabilities in this repository are to be resolved.
That is regardless of level of severity, eventually they'll be gone.

## Note

Could be considered common sense but for clarity; security vulnerabilities when adressed are pushed as the latest commit of whichever branch they're mentioned to be introduced in (but usually first pushed to `dev`).
Reporting about security vulnerabilities from commits older than 5-10 steps (depending on size of commits, merges and other changes) are given a lower priority due to the possible amount of changed files.

Of course, when contacting me about a security problem please do mention the commit when it were first introduced but more importantly, tell me where the issue currently is within the codebase of the latest commit/merge.

## Reporting a Vulnerability

Currently, I don't care much about the security vulnerabilities unless they're critical as this config is not yet my "daily driver".

Once this repository and config is stable I'll take a look at and attempt to fix any and all of them regardless of severity (instead of only high and critical).

For now, if you find a security issue (could be dependencies, sops-related, workflow, etc. or even a CVE) and you still want to let me know;
- Email: *might be added at a later time*
- Discord: `thepeario`

### Another way of contact

Create an issue/bug report, add the label `Security` (and level of severity if applicable) and tag me to get my attention.

Don't write what the vulnerability is, use the issue to let me know what [type of vulnerability](https://www.spiceworks.com/it-security/vulnerability-management/articles/what-is-a-security-vulnerability/#_002) 
it is (not restricted to that list) and [level of severity](https://www.atlassian.com/trust/security/security-severity-levels) (low, medium, high, critical).

From there we can talk about how to resolve the issue or move onto Discord or another social platform to talk there.
