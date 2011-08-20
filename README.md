Create .properties files from XML
=================================

    <config>
        <server>
            <id>me</id>
            <host>localhost</host>
            <port>8081</port>
        </server>
        <username>larsmoil</username>
    </config>

Becomes

    config.server.id=me
    config.server.host=localhost
    config.server.port=8081
    config.username=larsmoil

See it in action
----------------
The code can be seen live @ [Heroku](http://flatten-xml.heroku.com).
