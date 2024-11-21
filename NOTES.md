

Before Login : 
- Todos <Guests> (OK)
- Topics <Authenticated> (No user exception)
- Articles <Owners> (No user exception)
- Products <Guests, Authenticated> (OK)
- Learning Paths <Guests, Authenticated, Owners> (OK)

After Login :
- Todos <Guests> (Unauthorized)
- Topics <Authenticated> (OK)
- Articles <Owners> (OK)
- Products <Guests, Authenticated> (Unauthorized)
- Learning Paths <Guests, Authenticated, Owners> (Unauthorized)

