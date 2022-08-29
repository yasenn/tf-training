# The Self Provisioning Runtime

[The Self Provisioning Runtime](https://www.swyx.io/self-provisioning-runtime)

**If the Platonic ideal of Developer Experience is a world where you ”[Just Write Business Logic](https://twitter.com/swyx/status/1428740355994767369)”, the logical endgame is a language+infrastructure combination that figures out everything else.**

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/waips441uk8o9stb91ok.png)

Two paraphrases as assertions:

- People who are really serious about developer experience should make their own language or runtime. ([quote](https://www.brainyquote.com/quotes/alan_kay_375550))
- Developer Experience advances by extending the number of important problems our code handles without thinking of them. ([quote](https://en.wikiquote.org/wiki/Alfred_North_Whitehead#:~:text=Civilization%20advances%20by%20extending%20the,be%20made%20at%20decisive%20moments.))

> I feel a strong intuition of what the future of programming languages holds for practical (non-academic) developers, but lack the formal background to fully specify it. I’ll write down the parts of the elephant I feel, and hope that the rest is so obvious that you, dear reader, shout and scream at me to fill in the blanks of my ignorance. _Please get in touch!!! My ignorance could fill a (blank) book and I need to know who to follow and what to read._

 > **My central assertion**: Advancements in two fields — programming languages and cloud infrastructure — will converge in a single paradigm: where all resources required by a program will be **automatically** provisioned, and optimized, _by the environment that runs it_.


---

# 45 steps to Jamstack in AWS



as a user, I can set up a static website in AWS, but it takes 45 steps in the console and 12 of them are highly confusing if you never did it before. And it's also super slow to do it, and any time I make a mistake, I end up in some weird state where maybe I broke something terribly and I might have to start over. It's _sad_ this is the current state of infrastructure.

[Software infrastructure 2.0: a wishlist · Erik Bernhardsson](https://erikbern.com/2021/04/19/software-infrastructure-2.0-a-wishlist.html)

---

# Truly serverless

We are, like what, 10 years into the cloud adoption? Most companies (at least the ones I talk to) run their stuff in the cloud. So why is software still acting as if the cloud doesn't exist?

- The word _cluster_ is an anachronism to an end-user in the cloud! I'm already running things _in the cloud_ where there's elastic resources available at any time. Why do I have to think about the underlying pool of resources? Just maintain it for me.
- I don't ever want to _provision_ anything in advance of load.
- I don't want to pay for idle resources. Just let me pay for whatever resources I'm actually using.
- Serverless doesn't mean it's a burstable VM that saves its instance state to disk during periods of idle.

[Software infrastructure 2.0: a wishlist · Erik Bernhardsson](https://erikbern.com/2021/04/19/software-infrastructure-2.0-a-wishlist.html)

---

# Taxonomy of programming paradigms

Adrian Colyer also has [this work of art](https://blog.acolyer.org/2019/01/25/programming-paradigms-for-dummies-what-every-programmer-should-know/) which should satisfy the more rigorously inclined:

![ Taxonomy of programming paradigms](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/qo0cn6cme96kmgyn7q5p.png)

[The Self Provisioning Runtime](https://www.swyx.io/self-provisioning-runtime)


---

# Nitric.io

[Overview: Concepts | Nitric Documentation](https://nitric.io/docs/concepts)

Nitric is a framework for rapid development of cloud-native and serverless applications. It helps you define your apps in terms of the resources they need, then write the code for serverless function based APIs, event subscribers and scheduled jobs. Unlike other cloud or container frameworks, apps built with Nitric can be deployed to AWS, Azure or Google Cloud all from the same code base.

The agility and portability of Nitric means you can focus on your products, not your cloud provider.

---

# nitric.io

* [Nitric, a Cloud Portability Framework for Code – The New Stack](https://thenewstack.io/nitric-a-cloud-portability-framework-for-code/)
* [nitrictech/nitric: Nitric is a framework for cloud-native apps and infrastructure from code. It takes care of infrastructure and config without limiting your language or cloud, so you can spend your time writing application code.](https://github.com/nitrictech/nitric?utm_source=thenewstack&utm_medium=website&utm_campaign=platform)
* [Nitric Blog | Build Serverless Apps Fast](https://nitric.io/blog)
* [Nitric, a Cloud Portability Framework for Code | Hacker News](https://news.ycombinator.com/item?id=31046058)
* [Why we built a self-provisioning runtime | Nitric Blog](about:reader?url=https%3A%2F%2Fnitric.io%2Fblog%2Fself-provisioning-runtime)
* [The Self Provisioning Runtime](https://www.swyx.io/self-provisioning-runtime)
