# Marketing Factory Components

This project contains all the Marketing Factory components

## Build and deploy

Simply use the following command to build the project and deploy to Jahia

```
mvn clean install jahia:deploy -P jahia-7.0-tomcat
```

where the jahia-7.0-tomcat is a Maven profile pointing to an installed Jahia instance such as in the following example:

```
<profile>
    <id>jahia-7.0-tomcat</id>
    <properties>
        <jahia.deploy.targetServerType>tomcat</jahia.deploy.targetServerType>
        <jahia.deploy.targetServerVersion>7</jahia.deploy.targetServerVersion>
        <jahia.deploy.targetServerDirectory>/Users/loom/java/deployments/jahia-7.0/apache-tomcat-7.0.52
        </jahia.deploy.targetServerDirectory>
        <jahia.deploy.war.dirName>ROOT</jahia.deploy.war.dirName>
        <jahia.deploy.war.contextPath>/</jahia.deploy.war.contextPath>
        <jahia.deploy.war.servletPath>/cms</jahia.deploy.war.servletPath>
        <jahia.debug.address>socket:hostname=localhost,port=8000</jahia.debug.address>
    </properties>
</profile>
```

## How it works ?

#### Personalized News Retriever

The component used to retrieve the latest news according to the profile criteria and the entered parameters.

The criteria used to retrieve the list of news is:

* The news has a date property and according to this property, we filter the list of news which has a date on the range of the number of last days set by the editor.
* The news already seen by the visitor will not be showing on the list.
* The highest tag aggregation of the profile will be used to get news tagged by the same tag.

The following diagram show the sequence of interaction between components to retrieve le latest news.

![sequence diagram of Personalized News Retriever](https://user-images.githubusercontent.com/8075371/42930067-4b4cde50-8b3c-11e8-804f-1e4b76e76a19.png)

## Found a bug?

Please feel free to [create an issue](https://github.com/Jahia/Marketing-Factory-Components/issues) if you find anything wrong with this component.