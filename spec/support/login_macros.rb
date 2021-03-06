module LoginMacros
  def login(user)
    mock_auth_hash_slack(user)

    visit login_path
    find('#sign-in-slack').click

    path = if user.created?
      activate_users_path
    elsif user.suspended?
      root_path
    else # active or finished
      signed_in_root_path
    end

    expect(current_path).to eq(path)
  end
end
