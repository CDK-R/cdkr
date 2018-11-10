# Packaging CDK

The CDK2.0 release is 25MB. To try to reduce this size we built a version of the CDK libs that removes several sub-libraries.

```
git clone https://github.com/cdk/cdk.git

cd cdk/bundle

#checkout the tag of the released version
git checkout -b rcdk2 cdk2-2.0

vi pox.xml

# remove the entries for:
# builder3d
# builder3d-tools
# cdk-pdb
# cdk-pdbcml

mvn package
```

You can now use the target/cdk-2.0.jar for inclusion in rcdklibs


