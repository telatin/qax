import grim
var g = newGraph("my graph")

let 
  c1 = g.addNode("Country", %(name: "Sweden", GDP_per_capita: 53208.0))
  c2 = g.addNode("Country", %(name: "Norway", GDP_per_capita: 74536.0))
  c3 = g.addNode("Country", %(name: "Germany", GDP_per_capita: 52559.0))

  o1 = g.addNode("Organization", %(name: "NATO", founded: 1949, active: true))
  o2 = g.addNode("Organization", %(name: "EU", founded: 1993, active: true))
  o3 = g.addNode("Organization", %(name: "Nordic Council", founded: 1952))

let
  e1 = g.addEdge(c1, o2, "MEMBER_OF", %(since: 1995))
  e2 = g.addEdge(c1, o3, "MEMBER_OF", %(since: 1952))
  e3 = g.addEdge(c2, o3, "MEMBER_OF", %(since: 1952, membership: "full"))



