lambda do |env|

  headers = {}

  ## only allow accessing the following php files - fall through to next handler
  allowable_php = "^/(index|matomo|piwik|js/index|plugins/HeatmapSessionRecording/configs)\.php$"
  if /#{allowable_php}/.match(env["PATH_INFO"])
    return [399, headers, []]
  end

  ## deny access to all other .php files
  if /^.+\.php$/.match(env["PATH_INFO"])
    return [403, {'content-type' => 'text/plain'}, ["access forbidden\n"]]
  end

  ## disable all access to the following directories
  blockable_directories = "^/(config|tmp|core|lang)"
  if /#{blockable_directories}/.match(env["PATH_INFO"])
    return [403, {'content-type' => 'text/plain'}, ["access forbidden\n"]]
  end

  ## disable access to Apache files
  if /\/\.ht/.match(env["PATH_INFO"])
    return [403, {'content-type' => 'text/plain'}, ["access forbidden\n"]]
  end

  ## set caching headers for non-cacheable files
  non_cacheable_files = 'js/container_.*_preview\.js$'
  if /#{non_cacheable_files}/i.match(env["PATH_INFO"])
    headers["pragma"] = "no-cache"
    headers["cache-control"] = "no-store, max-age=0"
    return [399, headers, []]
  end

  ## set caching headers for cacheable files (30 days)
  cacheable_files = '^\/(matomo|piwik)\.js$'
  if /#{cacheable_files}/i.match(env["PATH_INFO"])
    headers["cache-control"] = "public, max-age=2592000"
    return [399, headers, []]
  end

  ## set caching headers for cacheable files (1h)
  cacheable_files = '\.(gif|ico|jpg|png|svg|js|css|htm|html|mp3|mp4|wav|ogg|avi|ttf|eot|woff|woff2|json)$'
  if /#{cacheable_files}/i.match(env["PATH_INFO"])
    headers["pragma"] = "public"
    headers["cache-control"] = "public, max-age=3600"
    return [399, headers, []]
  end

  ## disable all access to the following directories
  blockable_directories = "^\/(libs|vendor|plugins|misc|node_modules)"
  if /#{blockable_directories}/.match(env["PATH_INFO"])
    return [403, {'content-type' => 'text/plain'}, ["access forbidden\n"]]
  end

  [399, headers, []]
end
