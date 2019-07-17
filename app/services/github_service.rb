class GithubService
  attr_accessor :access_token

  def initialize(access_hash={})
    @access_token=access_hash["access_token"]
  end

  def authenticate!(client_id, client_secret, code)
    resp = Faraday.post "https://github.com/login/oauth/access_token",
        {client_id: client_id, client_secret: client_secret, code: code},
        {'Accept' => 'application/json'}
    access_hash = JSON.parse(resp.body)
    @access_token = access_hash["access_token"]
  end

  def get_username()
    user_response = Faraday.get "https://api.github.com/user", {}, {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}
    user_json = JSON.parse(user_response.body)
    user_json["login"]
  end

  def get_repos()
    response = Faraday.get "https://api.github.com/user/repos", {}, {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}
    @repos_array = JSON.parse(response.body)
    @repos_array.map{|repo| GithubRepo.new(repo) }
  end

  def create_repo(name)
    Faraday.post "https://api.github.com/user/repos", {name: name}.to_json, {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}
  end

end