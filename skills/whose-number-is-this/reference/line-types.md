# Line types and the messaging-app disclosure surface

Two lookup tables. The first tells you what kind of thing the number is; the
second tells you what a messaging platform will disclose about it, and at what
cost to your operational security and to the subject's privacy.

## Line types and what each implies

| Line type | Identity strength | What it tells you |
|---|---|---|
| Mobile (MNO-issued SIM) | Strongest | Usually tied to a subscriber contract or a prepaid registration. In countries with mandatory SIM registration, tied to identity documents |
| Fixed line | Strong for a premises, weak for a person | Attaches to an address, not an individual. Households and offices share it |
| VoIP / virtual | Weak | Cheap, instant, frequently anonymous. Can be discarded and replaced without cost |
| Toll-free | Organisational | Belongs to a business. Routes to a queue, not a person. Useful for corporate pivots |
| Premium rate / shared cost | Organisational | Revenue-generating service numbers. Rarely useful for personal attribution |
| Machine-to-machine ranges | Not a person | Assigned to devices, telematics, alarms. Rarely reachable by voice |
| Unallocated / not-possible | Nothing | The number is not assignable in that country. Usually a typo, a fake, or a wrongly guessed trunk prefix |

**eSIM and multi-SIM** blur the mobile category. One device can hold several
numbers on several networks, so "this is their mobile" is a weaker statement
than it used to be. Conversely, a single person may have a personal, a work, and
a service number, all real, all theirs.

## Reading a VoIP result

Signals that a number is virtual, in rough order of reliability:

1. The lookup explicitly reports line type VoIP or "non-fixed VoIP".
2. The allocated operator is a wholesale number-hosting or communications-API
   provider rather than a consumer carrier brand.
3. An HLR query returns nothing useful, because there is no home register entry
   for a number that is not on a mobile network.
4. The area code has no relationship to any other geographic evidence about the
   subject.
5. The number is adjacent to other numbers used by the same party — virtual
   numbers are often bought in blocks.

What VoIP does *not* tell you: that the user is malicious. Businesses,
remote workers, people who moved countries, and privacy-conscious individuals
all use VoIP for good reasons. Report it as a property of the number, framed as
"weak identity anchor", not as a verdict about the person.

## Messaging-app disclosure

Every entry here is an **interactive** check. You are asking a platform about a
specific person, from an account, and the platform logs it. Some of these
actions can also be visible to the subject. Treat the whole table as
authorization-gated, and re-read `investigate-without-getting-made` before you
touch it.

Platforms change privacy defaults frequently, and most now let users hide most
of this. Treat every row as "what the surface can expose when the user has not
locked it down", not as a guarantee.

| Disclosure | Typical availability | Investigative value |
|---|---|---|
| Registration (is this number on the platform at all) | The most consistently available fact across apps | Confirms the number is live and in active use. Registration across several apps suggests a primary personal number, not a burner |
| Display name | Often user-controlled, often a pseudonym | A lead for `hunt-a-handle` and `find-anyone`. Rarely a legal name |
| Profile photo | Frequently restricted to contacts by the user | The single best pivot here — send it to `find-the-original-image` |
| About / status text | Often visible when a photo is not | Occasionally contains a second contact selector or an employer |
| Last seen / online state | Widely hidden by default now | Pattern-of-life signal, and the most intrusive item in this table. Repeated observation of it edges toward surveillance — do not do it without explicit authorization |
| Username or handle (where the platform supports one separately from the number) | User-set, publicly resolvable on some platforms | Direct pivot to `hunt-a-handle` |
| Group membership | Visible only where you share a group | Out of scope unless you were already legitimately present |

## Cost and risk of doing this

- **Contact-list sync uploads your list.** If you add the subject's number to a
  device address book and let an app sync, you have disclosed that number, and
  every other number on the device, to the platform. Use a clean device and a
  clean account or don't do it.
- **You may become visible.** Some platforms surface "people who may know you"
  suggestions in both directions. A lookup can put your investigative account in
  front of the subject.
- **Bulk lookup is prohibited** by essentially every platform's terms, and
  triggers anti-abuse measures that will get the account banned mid-case.
- **Absence is not evidence.** A number not appearing on a platform may mean the
  user has disabled discoverability, not that they are not registered.

## Recording

For each check, record: platform, date and time, what was visible, what was
hidden, the account used, and the authorization reference that permitted the
check. Interactive steps must be distinguishable from passive ones in the final
report — a reader needs to know which findings came from touching the subject's
infrastructure.
