import { type ClientSchema, a, defineData } from '@aws-amplify/backend';

const schema = a.schema({

  Article: a
    .model({
      title: a.string(),
      content: a.string(),
    })
    .authorization((allow) => [
      allow.owner()
    ]),

  Topic: a
    .model({
      title: a.string(),
    })
    .authorization((allow) => [
      allow.authenticated()
    ]),

  Todo: a
    .model({
      content: a.string(),
    })
    .authorization((allow) => [allow.guest()]),
  
  Product: a
    .model({
      name: a.string(),
      description: a.string(),
    })
    .authorization((allow) => [
      allow.guest(),
      allow.authenticated(),
    ]),
    LearningPath: a
    .model({
      name: a.string(),
      description: a.string(),
    })
    .authorization((allow) => [
      allow.guest(),
      allow.authenticated(),
      allow.owner(),
    ]),
  

});

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: 'identityPool',
  },
});
