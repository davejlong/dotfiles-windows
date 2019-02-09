Param(
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
    [string] $GroupIdentity
)

Get-User -Filter (Get-DynamicDistributionGroup -Identity $GroupIdentity).RecipientFilter