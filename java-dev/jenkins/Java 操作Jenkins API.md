---
tags: note
status: todo
priority: 1
time: 2022-05-18 14:44
things:  "[🧊](things:///show?id=JtkDsmtmq6Bd8ZbzKBJTW4)"
---

# Jenkins API

利用 JAVA 操作 Jenkins API，实现对 Jenkins Job、View等等的增、删、改、查操作
## 介绍
Jenkins 远程 API 能够通过 Http 协议远程调用相关命令操作 Jenkins 进行 Jenkins 视图、任务、插件、构建信息、任务日志信息、统计信息等，非常容易与其配合更好的完成 CI/CD 工作。

## Jenkins API 格式
Jenkins API 总共有三种格式，分别为：

- [p] `JSON API`
- [p] `XML API`
- [p] `Python API`
## 查看jenkins API
浏览器打开Jenkins UI界面，对应URL地址栏后面追加 `/api/json` 或者 `/api/xml` ，效果如下：



## 调用接口前准备
要需要对jenkins的安全做一些设置，依次点击系统管理-全局安全配置-授权策略，勾选"匿名用户具有可读权限"
操作步骤：
- [d] 系统管理-全局安全配置-授权策略，勾选"匿名用户具有可读权限"

- 1、关闭 CSRF
由于在调用 `Jenkins` 中，操作执行 `Job` 一些命令时会用到 `Post` 方式命令，
所以需要关闭 `Jenkins` 的 `CSRF` 选项。
>站点伪造保护(CSRF)请求必须要关闭，但是在Jenkins版本自2.2xx版本之后，在web界面里已经没法关闭了：


2.2xx版本之前操作步骤：
- [d] 关闭 系统管理->全局安全配置->跨站请求伪造保护 选项

2.2xx版本之后操作步骤：
- [d] 通过docker进入到对应Jenkins容器，在容器内进行Jenkins.sh文件编写
```shell
docker exec -u root  -it myjenkins  bash
vi /usr/local/bin/jenkins.sh
```

找到`exec java`那行(大概是在第37行)，添加`-Dhudson.security.csrf.GlobalCrumbIssuerConfiguration.DISABLE_CSRF_PROTECTION=true`
最终的效果如下：

```shell
exec java -Duser.home="$JENKINS_HOME" -Dhudson.security.csrf.GlobalCrumbIssuerConfiguration.DISABLE_CSRF_PROTECTION=true "${java_opts_array[@]}" -jar ${JENKINS_WAR} "${jenkins_opts_array[@]}" "$@"
```
重启jenkins容器使设置生效
```shell
[root@vms9 ~]# docker restart jenkins
```
2、系统设置中和 jenkins 地址一致

操作步骤：
- [d] 设置 系统管理->系统设置->Jenkins Location 的 URL 和 Jenkins 访问地址保持一致
## 调用接口
```java
public class BaseJenkins {

    public static void main(String[] args) throws URISyntaxException, IOException {
        JenkinsServer jenkinsServer = new JenkinsServer(new URI("http://stuq.ceshiren.com:8080/"),
                "hogwarts", "hogwarts123");
        String pipeLine = "pipeline { \n" +
                            "agent any \n" +
                            "stages { \n" +
                            "stage('Stage 1') { \n" +
                                "steps { \n" +
                                    "echo \'Hello World\' \n" +
                                "} } } }";
        String jobConfigXml = "<flow-definition plugin=\"workflow-job@1181.va_25d15548158\">\n" +
                "<actions>\n" +
                "<org.jenkinsci.plugins.pipeline.modeldefinition.actions.DeclarativeJobAction plugin=\"pipeline-model-definition@2.2081.v3919681ffc1e\"/>\n" +
                "<org.jenkinsci.plugins.pipeline.modeldefinition.actions.DeclarativeJobPropertyTrackerAction plugin=\"pipeline-model-definition@2.2081.v3919681ffc1e\">\n" +
                "<jobProperties/>\n" +
                "<triggers/>\n" +
                "<parameters/>\n" +
                "<options/>\n" +
                "</org.jenkinsci.plugins.pipeline.modeldefinition.actions.DeclarativeJobPropertyTrackerAction>\n" +
                "</actions>\n" +
                "<description>测试项目</description>\n" +
                "<keepDependencies>false</keepDependencies>\n" +
                "<properties/>\n" +
                "<definition class=\"org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition\" plugin=\"workflow-cps@2692.v76b_089ccd026\">\n" +
                "<script>"+pipeLine+"</script>\n" +
                "<sandbox>true</sandbox>\n" +
                "</definition>\n" +
                "<disabled>false</disabled>\n" +
                "</flow-definition>";
//        jenkinsServer.createJob("atest0420051",jobConfigXml,true);
        jenkinsServer.getJob("atest0420051").build(true);
    }
}
```
### 编写jenkinsJobAPI
```java
public class Jenkins {

    private String url;
    /**
     * 用户名
     */
    private String user;

    /**
     * 密码
     */
    private String password;

    /**
     * 生成job的xml
     */
    private String xmlpath;

    /**
     * job名称
     */
    private String job;
    

    /**
     * 默认Jenkins服务器
     */
    private Integer defaultJenkinsId;
}
```
```java
package top.testeru.sbm.utils.jenkins;

import com.offbytwo.jenkins.JenkinsServer;
import com.offbytwo.jenkins.client.JenkinsHttpClient;
import com.offbytwo.jenkins.model.*;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import top.testeru.sbm.dto.JenkinsDTO;
import top.testeru.sbm.entity.Jenkins;
import top.testeru.sbm.utils.FileUtil;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.util.HashMap;
import java.util.Map;

/**
 * Job(任务) 相关操作
 *
 * 例如对任务的增、删、改、查等操作
 */
public class JobApi {

    // Jenkins 对象
    private static JenkinsServer jenkinsServer;

    /**
     * 连接 Jenkins
     */

    static JenkinsServer build(Jenkins jenkins) {
        if (jenkinsServer == null) {
            try {
                jenkinsServer = new JenkinsServer(new URI(jenkins.getUrl()),
                        jenkins.getUser(), jenkins.getPassword());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return jenkinsServer;
    }

    /**
     * 创建 Job
     */
    public static void createJob(Jenkins jenkins){
        try {
            ClassPathResource classPathResource = new ClassPathResource(jenkins.getXmlpath());
            InputStream inputStream = classPathResource.getInputStream();
            String jobConfigXml = FileUtil.getText(inputStream);
            // 创建 Job
            build(jenkins).createJob(jenkins.getJob(),jobConfigXml,true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 更新 Job
     */
    public void updateJob(String jobName,String jobXmlPath){
        try {
            // 创建 Job
            jenkinsServer.updateJob(jobName,jobXmlPath,true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    /**
     * 获取 View 名称获取 Job 列表
     */
    public void getJobListByView(){
        try {
            // 获取 Job 列表
            Map<String,Job> jobs = jenkinsServer.getJobs("all");
            for (Job job:jobs.values()){
                System.out.println(job.getName());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    /**
     * 执行无参数 Job build
     */
    public static void buildJob(Jenkins jenkins){
        try {
            build(jenkins).getJob(jenkins.getJob()).build(true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 执行带参数 Job build
     */
    public static void buildParamJob(Jenkins jenkins){
        try {
            /**
             * 例如，现有一个job，拥有一个字符参数"key"
             * 现在对这个值进行设置，然后执行一个输出这个值的脚本
             */

            // 执行 build 任务
            build(jenkins).getJob(jenkins.getJob()).build(jenkins.getParam(),true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 删除 Job
     */
    public static void deleteJob(Jenkins jenkins){
        try {
            build(jenkins).deleteJob(jenkins.getJob(),true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

```

### 编写service层
#### 编写接口
```java
public interface JenkinsService {

    String build(JenkinsDTO jenkinsDTO);

    String create(JenkinsDTO jenkinsDTO);
}
```
#### 编写实现类
```java
@Service
public class JenkinsServiceImpl  implements JenkinsService {

    @Autowired
    JenkinsConverter jenkinsConverter;
    // 连接 Jenkins 需要设置的信息
    @Value("${jenkins.url}")
    private  String JENKINS_URL;
    @Value("${jenkins.username}")
    private  String JENKINS_USERNAME;
    @Value("${jenkins.password}")
    private  String JENKINS_PASSWORD ;
    
    JenkinsDTO setJenkinsService(Jenkins jenkins){
        jenkins.setUrl(JENKINS_URL);
        jenkins.setUser(JENKINS_USERNAME);
        jenkins.setPassword(JENKINS_PASSWORD);
        return jenkinsConverter.jenkinsForjenkinsDto(jenkins);
    }

    @Override
    public String build(JenkinsDTO jenkinsDTO) {
        Jenkins jenkins = jenkinsConverter.jenkinsDtoForJenkins(jenkinsDTO);
        setJenkinsService(jenkins);
        System.out.println(jenkins);
        JobApi.buildJob(jenkins);
        return null;
    }

    @Override
    public String create(JenkinsDTO jenkinsDTO) {
        Jenkins jenkins = jenkinsConverter.jenkinsDtoForJenkins(jenkinsDTO);
        setJenkinsService(jenkins);
        System.out.println(jenkins);
        JobApi.createJob(jenkins);
        return null;
    }
}
```

```java
@Mapper(componentModel = "spring")
public interface JenkinsConverter {
    @Mappings({
            @Mapping(target = "xmlpath",source = "xmlpath"),
            @Mapping(target = "job",source = "job"),
            @Mapping(target = "defaultJenkinsId",source = "defaultJenkinsId"),
            @Mapping(target = "param",source = "param")
    })
    Jenkins jenkinsDtoForJenkins(JenkinsDTO jenkinsDTO);
    @Mappings({
            @Mapping(target = "xmlpath",source = "xmlpath"),
            @Mapping(target = "job",source = "job"),
            @Mapping(target = "defaultJenkinsId",source = "defaultJenkinsId"),
            @Mapping(target = "param",source = "param")
    })
    JenkinsDTO jenkinsForjenkinsDto(Jenkins jenkins);
    @Mappings({
            @Mapping(target = "xmlpath",source = "xmlpath"),
            @Mapping(target = "job",source = "job"),
            @Mapping(target = "defaultJenkinsId",source = "defaultJenkinsId"),
            @Mapping(target = "param",source = "param")
    })
    List<Jenkins> UserDTOListForUserList(List<JenkinsDTO> jenkinsDTOList);
    @Mappings({
            @Mapping(target = "xmlpath",source = "xmlpath"),
            @Mapping(target = "job",source = "job"),
            @Mapping(target = "defaultJenkinsId",source = "defaultJenkinsId")
    })
    List<JenkinsDTO> UserListForUserDTOList(List<Jenkins> jenkinsList);
}
```

### 编写controller层
```java
@RestController
@RequestMapping("jenkins")
public class JenkinsController {
    @Autowired
    JenkinsService jenkinsService;

    @PostMapping(value = "build",produces = "application/json")
    void updateJob(@RequestBody JenkinsDTO jenkinsDTO){
        jenkinsService.build(jenkinsDTO);
    }
    @PostMapping(value = "create",produces = "application/json")
    void createJob(@RequestBody JenkinsDTO jenkinsDTO){
        jenkinsService.create(jenkinsDTO);
    }
    
}
```


2、 JenkinsJobAPI工具类创建
- [p] Job(任务) 相关操作
>例如对任务的增、删、改、查等操作

 
获取Job的xml：
创建job，进入job对应的配置页面，对应地址栏内容修改：`configure`改为`config.xml`，则可以看到对应的xml文件


带参数数job-build

```java
public class JobApi {
    /**
     * 执行带参数 Job build
     */
    public static void buildParamJob(Jenkins jenkins) {
        try {
            /**
             * 例如，现有一个job，拥有一个字符参数"key"
             * 现在对这个值进行设置，然后执行一个输出这个值的脚本
             */

            // 执行 build 任务
            build(jenkins).getJob(jenkins.getJob()).build(jenkins.getParam(), true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```


```java
    @Override
    public String build(JenkinsDTO jenkinsDTO) {
        Jenkins jenkins = jenkinsConverter.jenkinsDtoForJenkins(jenkinsDTO);
        setJenkinsService(jenkins);
        System.out.println(jenkins);
        if(jenkins.getParam().isEmpty()){
            JobApi.buildJob(jenkins);
        }else {
            JobApi.buildParamJob(jenkins);

        }
        return null;
    }
```


```shell
{
    "buildjob":"test-create1",
    "param":{
        "updateStatusData":"fdsa",
        "testCommand":"pwd"
    }
}
```

