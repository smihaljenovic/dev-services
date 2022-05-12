db.createUser({
    user: 'admin',
    pwd: 'admin',
    roles: [{
        db: 'admin',
        role: 'readWrite'
    }, {
        db: 'admin',
        role: 'userAdminAnyDatabase'
    }, {
        db: 'admin',
        role: 'dbAdminAnyDatabase'
    }]
})
