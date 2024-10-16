这里我们使用snakemaake搭建了一个 PacBio_sv_detect 的流程，主要包含以下步骤：

1. 环境配置：需要安装在 **env** 目录的三个conda环境文件
2. 准备数据和配置文件：

如:样本信息配置
```yaml
samples:
    # sample or id to use for generating targets
    id_list: ["HG002_30X"]
    cram_path: "/BIGDATA2/gzfezx_shhli_2/USER/luozhenyu/20240124_EBV_Dengue/input_all"
```
3. 分析数据：
```shell
sh run_snakemake.sh
```