MatCon Service
==============

**Filtering**

For filtering the API takes "where" as a URL parameter. e.g.

http://eve-demo.herokuapp.com/people?where={"lastname": "Doe"}

Because where is always a hash this makes it simple to build the query i.e.

People.where(lastname: "Doe")

http://eve-demo.herokuapp.com/people?where={"born": {"$gte":"Wed, 25 Feb 1987 17:00:00 GMT"}}

People.where(born: { "$gte": "Wed, 25 Feb 1987 17:00:00 GMT"} })

** Sorting **

http://eve-demo.herokuapp.com/people?sort=city,-lastname

would sort by city and then lastname descending

People.order("city", "-lastname")

OR do it the Active Query way

People.order(city: :asc, lastname: :desc)

** Pagination **

http://eve-demo.herokuapp.com/people?max_results=20&page=2

People.limit(20).page(2)

OR

People.max_results(20).page(2)

** Projections **

http://eve-demo.herokuapp.com/people?projection={"lastname": 1, "born": 1}

People.projection(lastname: true, born: true)

http://eve-demo.herokuapp.com/people?projection={"born": 0}

People.projection(born: 0)

** Embedding **

/emails?embedded={"author":1}

Email.embed(author: 1) OR Email.embed(:author) i.e. if it's a Hash use that, if not create a Hash where values default to 1



