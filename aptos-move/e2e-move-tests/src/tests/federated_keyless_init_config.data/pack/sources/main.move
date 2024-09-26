script {
    use aptos_framework::aptos_governance;
    use aptos_framework::jwks;
    use aptos_framework::keyless_account;

    fun main(core_resources: &signer, max_exp_horizon_secs: u64) {
        let fx = aptos_governance::get_signer_testnet_only(core_resources, @aptos_framework);

        keyless_account::update_max_exp_horizon_for_next_epoch(&fx, max_exp_horizon_secs);

        // remove all the JWKs in 0x1 (since we will be reusing the iss as a federated one; and we don't want the 0x1 JWKs to take priority over our federated JWKs)
        let patches = vector[
            jwks::new_patch_remove_all(),
        ];
        jwks::set_patches(&fx, patches);

        // sets the pending Configuration change to the max expiration horizon from above
        aptos_governance::force_end_epoch_test_only(core_resources);
    }
}