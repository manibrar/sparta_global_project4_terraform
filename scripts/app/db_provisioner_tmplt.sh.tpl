#!/bin/bash

mongo mongodb://10.10.4.7/rs0
rs.initiate({ _id: "rs0", members: [ { _id: 0, host : "10.10.4.7" }, { _id: 1, host : "10.10.5.7" }, { _id: 2, host : "10.10.6.7" } ] })
db.isMaster()
rs.slaveOk()
quit()
